package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_path_primaryContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Module_path_primaryContextExt extends AbstractBaseExt {

	public Module_path_primaryContextExt(Module_path_primaryContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Module_path_primaryContext getContext() {
		return (Module_path_primaryContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).module_path_primary());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Module_path_primaryContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Module_path_primaryContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}