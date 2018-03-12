package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PortCap_cContext;

public class PortCap_cContextExt extends AbstractBaseExt {

	public PortCap_cContextExt(PortCap_cContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortCap_cContext getContext() {
		return (PortCap_cContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).portCap_c());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortCap_cContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortCap_cContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
