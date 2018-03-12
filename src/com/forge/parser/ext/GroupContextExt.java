package com.forge.parser.ext;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.FieldContext;
import com.forge.parser.gen.ForgeParser.GroupContext;

public class GroupContextExt extends AbstractBaseExt {
	public GroupContextExt(GroupContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public GroupContext getContext() {
		return (GroupContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).group());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof GroupContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + GroupContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public void duplicateNamesCheck(String parentName, List<String> names) {
		GroupContext ctx = getContext();
		String name = ctx.group_identifier().extendedContext.getFormattedText();
		if (names.contains(name)) {
			throw new IllegalStateException(
					"Duplicate group with name " + name + " inside " + parentName + " in line " + ctx.start.getLine());
		} else {
			names.add(name);
		}
		List<String> fieldInGroup = new ArrayList<>();
		for (FieldContext fieldContext : ctx.field()) {
			fieldContext.extendedContext.duplicateNamesCheck(name, fieldInGroup);
		}
	}

	@Override
	protected void getSemanticInfo(HashMap<String, String> propStore) {
		GroupContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			if (!propStore.containsKey("group")) {
				propStore.put("group", ctx.group_identifier().extendedContext.getFormattedText());
			}
		}
	}

	@Override
	public void calculateFieldOffset(AtomicInteger offset) {
		offset.set(0);
		super.calculateFieldOffset(offset);
	}
}
