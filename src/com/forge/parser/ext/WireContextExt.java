package com.forge.parser.ext;

import java.util.HashMap;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.WireContext;

public class WireContextExt extends AbstractBaseExt {

	public WireContextExt(WireContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public WireContext getContext() {
		return (WireContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).wire());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof WireContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + WireContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected void getSemanticInfo(HashMap<String, String> propStore) {
		WireContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			if (!propStore.containsKey("wires")) {
				propStore.put("wires", ctx.wire_identifier().extendedContext.getFormattedText());
			}
		}
	}

	@Override
	protected void arrayPropertyCheck(String parentName) {
		WireContext ctx = getContext();
		String name = ctx.wire_identifier().extendedContext.getFormattedText();
		super.arrayPropertyCheck(name);
	}
}
