package com.forge.parser.ext;

import java.util.HashMap;
import java.util.List;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.KeyContext;

public class KeyContextExt extends AbstractBaseExt {

	public KeyContextExt(KeyContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public KeyContext getContext() {
		return (KeyContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).number());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof KeyContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + KeyContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	public String getName(String name) {
		KeyContext ctx = getContext();
		name = ctx.key_identifier().extendedContext.getFormattedText();
		return name;
	}

	@Override
	public void duplicateNamesCheck(String parentName, List<String> names) {
		KeyContext ctx = getContext();
		String name = ctx.key_identifier().extendedContext.getFormattedText();
		if (names.contains(name)) {
			throw new IllegalStateException(
					"Duplicate key with name " + name + " inside " + parentName + " in line " + ctx.start.getLine());
		} else {
			names.add(name);
		}
	}

	@Override
	protected void getSemanticInfo(HashMap<String, String> propStore) {
		KeyContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			if (!propStore.containsKey("key")) {
				propStore.put("key", ctx.key_identifier().extendedContext.getFormattedText());
			}
		}
	}
}
