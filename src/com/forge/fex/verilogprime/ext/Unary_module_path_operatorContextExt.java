package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Unary_module_path_operatorContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Unary_module_path_operatorContextExt extends AbstractBaseExt {

	public Unary_module_path_operatorContextExt(Unary_module_path_operatorContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Unary_module_path_operatorContext getContext() {
		return (Unary_module_path_operatorContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).unary_module_path_operator());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Unary_module_path_operatorContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Unary_module_path_operatorContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}