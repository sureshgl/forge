package com.forge.parser.ext;

import java.util.HashMap;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.IR.IBits;
import com.forge.parser.gen.ForgeParser.BitsContext;

public class BitsContextExt extends AbstractBaseExt implements IBits {

	public BitsContextExt(BitsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public BitsContext getContext() {
		return (BitsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bits());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof BitsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + BitsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected void getSemanticInfo(HashMap<String, String> propStore) {
		BitsContext ctx = getContext();
		if (!propStore.containsKey("bits")) {
			propStore.put("bits", ctx.id_or_number().extendedContext.getFormattedText());
		} else {
			throw new IllegalStateException("In Memory bits is duplicated " + ctx.extendedContext.getFormattedText() + " in memory "
					+ propStore.get("memName") + " in line " + ctx.start.getLine());
		}
	}

	@Override
	public Integer getBits() {
		BitsContext ctx = getContext();
		return Integer.valueOf(ctx.id_or_number().extendedContext.getFormattedText());
	}
}
